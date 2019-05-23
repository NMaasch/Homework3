Shader "Custom/ParticleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Start ("Start Color",COLOR) = (1.0,0.0,0.0,1.0)
        _End ("End Color",COLOR) = (1.0,1.0,1.0,1.0)
        _Mag("Magnitude",Float) = 0
        //Define properties for Start and End Color
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Opaque" }
        LOD 100
        
        Blend One One
        ZWrite off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
                float4 color: COLOR;

                //Define UV data
            };

            struct v2f
            {   
                float4 vertex : SV_POSITION;
                float3 uv : TEXCOORD0;
                float4 color: COLOR; 
                //Define UV data
            };

            sampler2D _MainTex;
            float4 _Start;
            float4 _End;
            float _Mag;
          

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.uv; Correct this for particle shader
                o.uv = v.uv;
                o.uv.z = v.uv.z;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //Get particle age percentage
                float age = i.uv.z;
                //Sample color from particle texture
                float4 color = i.color.xyzw;
                float minimag = _Mag;
                float4 magcolor = float4(minimag, minimag - 0.5,minimag - 0.5, 1.0 );
                float4 newstart = _Start + magcolor;
                float4 newend = magcolor - float4(0.5,0.0,-2.0,1.0);
                //Do a linear interpolation of start color and end color based on particle age percentage
                return float4( lerp( magcolor, newend, age)*tex2D(_MainTex,i.uv));
                //return float4(1,1,1,1);
            }
            ENDCG
        }
    }
}
