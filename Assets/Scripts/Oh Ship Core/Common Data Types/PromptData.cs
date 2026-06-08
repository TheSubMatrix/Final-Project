using System;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// Data that can be applied to a UI widget via its <see cref="GameObject"/>
/// </summary>
[Serializable]
public class PromptData
{
    /// <summary>
    /// Applies the prompt data to a given UI widget
    /// </summary>
    /// <param name="gameObject">The <see cref="GameObject"/> to apply this prompt data to</param>
    public virtual void Apply(GameObject gameObject){}

    public string AssociatedWidget;
}
