using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

public class Fish : MonoBehaviour
{
    [Title("Fish")] 
    
    [SerializeField] public Vector3 speed;
    [SerializeField] public float acceleration; // acceleration doesn't need to be a Vector 3 since it will always follow the forward direction or the LeaderFish
    [SerializeField] protected float maxSpeed;
    [SerializeField] protected Aquarium myAquarium;

    private Vector3 _localPosition;
    protected Vector3 _localDirection; // Direction vector that allows to change the direction of the followerFish to the LeaderFish
    
    protected void Start()
    {
        _localPosition = transform.position;
        _localDirection = speed.normalized;
    }

    protected Vector3 GetMovement()
    {
        speed += Time.deltaTime * acceleration * _localDirection; //clamp speed to a max speed according to it's magnitude
        speed = Vector3.ClampMagnitude(speed, maxSpeed);
        
        _localPosition += Time.deltaTime * speed;
        return _localPosition;
    }
    
    protected void CheckBounds()
    {
        if (transform.localPosition.x < myAquarium.Origin.x - myAquarium.Bounds.x / 2)
        {
            speed = Vector3.Reflect(speed, new Vector3(-1, 0, 0));
        }
        if (transform.localPosition.x > myAquarium.Origin.x + myAquarium.Bounds.x / 2)
        {
            speed = Vector3.Reflect(speed, new Vector3(1, 0, 0));
        }
        if (transform.localPosition.y < myAquarium.Origin.y - myAquarium.Bounds.y / 2)
        {
            speed = Vector3.Reflect(speed, new Vector3(0, -1, 0));
        }
        if (transform.localPosition.y > myAquarium.Origin.y + myAquarium.Bounds.y / 2 )
        {
            speed = Vector3.Reflect(speed, new Vector3(0, 1, 0));

        }
        if (transform.localPosition.z < myAquarium.Origin.z - myAquarium.Bounds.z / 2)
        {
            speed = Vector3.Reflect(speed, new Vector3(0, 0, -1));

        }
        if (transform.localPosition.z > myAquarium.Origin.z + myAquarium.Bounds.z / 2)
        {
            speed = Vector3.Reflect(speed, new Vector3(0, 0, 1));
        }
        _localDirection = speed.normalized;
    }
}