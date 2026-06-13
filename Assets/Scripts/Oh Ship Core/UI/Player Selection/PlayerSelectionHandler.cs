using System;
using System.Collections.Generic;
using JetBrains.Annotations;
using MatrixUtils.Attributes;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class PlayerSelectionHandler : MonoBehaviour, IPlayerSelectionHandler, IDependencyProvider
{
    [SerializeReference, ClassSelector] List<IPlayerSelection> m_playerSelections;
    [Provide, UsedImplicitly] IPlayerSelectionHandler Provide() => this;

    public bool TryConfirmSelection(IPlayerControllable selector, IPlayerSelection target) => target?.TryAddSelector(selector) ?? false;
    public bool TryCancelSelection(IPlayerControllable selector, IPlayerSelection current) => current?.TryRemoveSelector(selector) ?? false;

    public bool TryGetNextAvailableSelection(
        IPlayerControllable selector,
        IPlayerSelection currentSelection,
        Vector2 direction,
        out IPlayerSelection nextSelection)
    {
        nextSelection = null;
        if (m_playerSelections.Count == 0) return false;
        int currentIndex = m_playerSelections.IndexOf(currentSelection);
        int step = direction.x > 0f || direction.y < 0f ? 1 : -1;
        int start = currentIndex == -1 ? 0 : Mathf.Clamp(currentIndex + step, 0, m_playerSelections.Count - 1);
        for (int i = start; i >= 0 && i < m_playerSelections.Count; i += step)
        {
            IPlayerSelection candidate = m_playerSelections[i];
            if (candidate == currentSelection) break;
            if (!candidate.AllowsMultipleSelectors && !candidate.IsAvailableTo(selector)) continue;
            nextSelection = candidate;
            return true;
        }
        return false;
    }

}