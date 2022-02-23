using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeaderFish : Fish
{
    void Update()
    {
        CheckBounds();
        
        transform.LookAt(GetMovement());
        transform.position = GetMovement();
    }
}
