using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class BouncingFish : Fish
{
    void Update()
    {
        CheckBounds();
        
        transform.LookAt(GetMovement());
        transform.position = GetMovement();
    }
    
}
