using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class FollowerFish : Fish
{
    [Title("FollowerFish")] 
    [SerializeField] private float sightDistance;
    [SerializeField] private float sightDotAngle;

    private LeaderFish myLeaderFish;

    void Update()
    {
        CheckBounds();
        
        if (myLeaderFish == null)
        {
            foreach (var fish in myAquarium.FishInAquarium)
            {
                if (fish != this.gameObject && fish.TryGetComponent<LeaderFish>(out LeaderFish leaderFish)&&
                    Vector3.Distance(fish.transform.position, transform.position) <= sightDistance)
                {
                    float dotProduct = Vector3.Dot(fish.transform.forward, transform.forward);
                    Debug.Log(dotProduct);
                    if (dotProduct > sightDotAngle)
                    {
                        myLeaderFish = leaderFish;
                        Debug.Log("2");
                        break;
                    }
                }
            }
        }

        if (myLeaderFish != null)
        {
            _localDirection = (myLeaderFish.transform.position - transform.position).normalized;
            Debug.Log("hey");
        }

        transform.LookAt(GetMovement());
        transform.position = GetMovement();
    }
}