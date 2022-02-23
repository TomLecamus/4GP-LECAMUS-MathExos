using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ballistic : MonoBehaviour
{
    [SerializeField] private Vector3 _speed = Vector3.zero;
    [SerializeField, Range(0, 20)] private int _pathLength = 0;
    [SerializeField, Range(0, 20)] private int _pointDensity = 0;
    [SerializeField] private LineRenderer myLineRenderer;

    private void OnValidate()
    {
        myLineRenderer.positionCount = _pathLength * _pointDensity;

        Vector3 pos = Vector3.zero;
        Vector3 speed = _speed;

        for (int PosIndex = 1; PosIndex < myLineRenderer.positionCount; PosIndex++)
        {
            speed += (float) 1 / _pointDensity * Physics.gravity;
            pos += (float) 1 / _pointDensity * speed;

            myLineRenderer.SetPosition(PosIndex, pos);
        }
    }
}
