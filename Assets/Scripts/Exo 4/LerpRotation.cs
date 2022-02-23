using System.Collections;
using System.Collections.Generic;
using UnityEngine;

class LerpRotation : AbstractLerp
{
    [SerializeField] private Vector3 _desiredRotation;
    private Quaternion _initialRotation;
    private Quaternion _desiredRotationQuaternion;

    private void Awake()
    {
        _initialRotation = transform.rotation;
        _desiredRotationQuaternion = Quaternion.Euler(_desiredRotation);
    }

    public override void AbstractLerping(float interpolant)
    {
        transform.localRotation = (Quaternion.LerpUnclamped(_initialRotation, _desiredRotationQuaternion, interpolant));
    }
}
