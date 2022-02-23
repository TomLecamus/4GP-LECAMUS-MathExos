using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using Sirenix.OdinInspector;
using Random = UnityEngine.Random;

public class FishSpawner : MonoBehaviour
{
    [SerializeField] private GameObject[] fishToSpawn;
    [SerializeField] private int[] numberOfFishToSpawn;
    [SerializeField] protected Aquarium myAquarium;
    [SerializeField,MinMaxSlider(-20, 20, true)] private Vector2 randomSpeedRange;
    [SerializeField,MinMaxSlider(0, 5, true)] private Vector2 randomAccelerationRange;

    void Start()
    {
        myAquarium.FishInAquarium.Clear();
        
        for (int i = 0; i < fishToSpawn.Length; i++)
        {
            for (int j = 0; j < numberOfFishToSpawn[i]; j++)
            {
                Vector3 spawnPos = myAquarium.Origin + new Vector3(
                    Random.Range(-myAquarium.Bounds.x/2, myAquarium.Bounds.x/2),
                    Random.Range(-myAquarium.Bounds.y/2, myAquarium.Bounds.y/2),
                    Random.Range(-myAquarium.Bounds.z/2, myAquarium.Bounds.z/2));
            
                GameObject fishInstance = Instantiate(fishToSpawn[i], spawnPos, quaternion.identity,transform);
                fishInstance.GetComponentInChildren<MeshRenderer>().material.color = Random.ColorHSV();
                
                Fish fishScript = fishInstance.GetComponent<Fish>();
                
                fishScript.speed = new Vector3(Random.Range(-randomSpeedRange.x, randomSpeedRange.y), Random.Range(-randomSpeedRange.x, randomSpeedRange.y), Random.Range(-randomSpeedRange.x, randomSpeedRange.y));
                fishScript.acceleration = Random.Range(randomAccelerationRange.x, randomAccelerationRange.y);
                
                myAquarium.AddFishToAquarium(fishInstance);
            }
        }
    }
}