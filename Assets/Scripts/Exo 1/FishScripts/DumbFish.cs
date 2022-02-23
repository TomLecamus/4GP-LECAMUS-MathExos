using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class DumbFish : Fish
{
    [Title("DumbFish")]
    
    [SerializeField,MinMaxSlider(-20, 20, true)] private Vector2 randomSpeedRange;
    [SerializeField,MinMaxSlider(0, 5, true)] private Vector2 randomAccelerationRange;
    private void Awake()
    {
        speed = new Vector3(Random.Range(-randomSpeedRange.x, randomSpeedRange.y), Random.Range(-randomSpeedRange.x, randomSpeedRange.y), Random.Range(-randomSpeedRange.x, randomSpeedRange.y));
        acceleration = Random.Range(randomAccelerationRange.x, randomAccelerationRange.y);
    }
    
    private void Update()
    {
        transform.LookAt(GetMovement());
        transform.position = GetMovement();
    }
}
