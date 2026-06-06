using System;
using UnityEngine;

public interface ITransitionHider
{
    public bool IsFading { get; }
    public bool FadeIn(float duration, Action onComplete = null);
    public bool FadeOut(float duration, Action onComplete = null);
}
