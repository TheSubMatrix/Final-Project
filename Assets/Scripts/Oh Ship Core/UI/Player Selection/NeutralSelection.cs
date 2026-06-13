using System;
using System.Collections.Generic;
using UnityEngine;
[Serializable]
public class NeutralSelection : IPlayerSelection
{
    [field:SerializeField] public Transform Transform { get; private set; }
    public bool AllowsMultipleSelectors => true;

    readonly HashSet<IPlayerControllable> m_selectors = new();

    public bool TryAddSelector(IPlayerControllable selector)
    {
        m_selectors.Add(selector);
        return true;
    }

    public bool TryRemoveSelector(IPlayerControllable selector) => m_selectors.Remove(selector);
    public bool IsSelectedBy(IPlayerControllable selector) => m_selectors.Contains(selector);
    public bool IsAvailableTo(IPlayerControllable selector) => true;
}