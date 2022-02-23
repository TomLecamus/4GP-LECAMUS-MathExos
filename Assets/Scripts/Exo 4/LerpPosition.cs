using System.Collections;
using System.Collections.Generic;
using UnityEngine;

class LerpPosition : AbstractLerp
{
    [SerializeField] private Vector3 _destination;
    private Vector3 _initialPosition;

    private void Awake()
    {
        _initialPosition = transform.position;
    }

    public override void AbstractLerping(float interpolant)
    {
        transform.position = Vector3.LerpUnclamped(_initialPosition, _destination, interpolant);
    }
}
