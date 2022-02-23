using System.Collections;
using System.Collections.Generic;
using UnityEngine;

abstract class AbstractLerp : MonoBehaviour
{

    [SerializeField] private AnimationCurve _curve;
    private float _totalTime;
    [SerializeField] private float _lerpTime;
    public abstract void AbstractLerping(float interpolant);

    private void Start()
    {
        StartCoroutine(ILerp());
    }

    IEnumerator ILerp()
    {
        while (_totalTime < _lerpTime)
        {
            _totalTime += Time.deltaTime;
            AbstractLerping(_curve.Evaluate(_totalTime/ _lerpTime));
            yield return new WaitForEndOfFrame();
        }
    }
}