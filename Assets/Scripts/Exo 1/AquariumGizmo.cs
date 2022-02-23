using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AquariumGizmo : MonoBehaviour
{
    [SerializeField] private Aquarium my_Aquarium;
    [SerializeField] private bool _showAquariumBounds;

    private void OnDrawGizmos()
    {
        if (my_Aquarium && _showAquariumBounds) Gizmos.DrawWireCube(my_Aquarium.Origin, my_Aquarium.Bounds);
    }
}
