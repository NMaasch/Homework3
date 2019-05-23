using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleScript : MonoBehaviour
{

    ParticleSystem ps;
    ParticleSystem.MainModule main;
    Renderer rend;

    void Start()
    {
        ps = gameObject.GetComponent<ParticleSystem>();
        main = ps.main;
        rend = gameObject.GetComponent<Renderer>();
        rend.material.shader = Shader.Find("Custom/ParticleShader");
    }
    // Update is called once per frame
    void Update()
    {
        int numPartitions = 1;
		float[] aveMag = new float[numPartitions];
		float partitionIndx = 0;
		int numDisplayedBins = 512 / 2; 

		for (int i = 0; i < numDisplayedBins; i++) 
		{
			if(i < numDisplayedBins * (partitionIndx + 1) / numPartitions){
				aveMag[(int)partitionIndx] += AudioPeer.spectrumData [i] / (512/numPartitions);
			}
			else{
				partitionIndx++;
				i--;
			}
		}

		for(int i = 0; i < numPartitions; i++)
		{
			aveMag[i] = (float)0.5 + aveMag[i]*100;
			if (aveMag[i] > 100) {
				aveMag[i] = 100;
			}
		}

		float mag = aveMag[0];
        //float mag2 = aveMag[7]
        rend.material.SetFloat("_Mag",mag);
        Debug.Log(mag);
        var mai = ps.main;
        if(mag > .75){
			ps.Emit(20);
		}
        
    }
}
