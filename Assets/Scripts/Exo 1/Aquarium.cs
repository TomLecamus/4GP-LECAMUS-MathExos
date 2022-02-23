using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/Aquarium", order = 1)]
public class Aquarium : ScriptableObject
{

    public Vector3 Bounds;
    public Vector3 Origin;
    public List<GameObject> FishInAquarium;

    public void AddFishToAquarium(GameObject Fish)
    {
        FishInAquarium.Add(Fish);
    }
}
