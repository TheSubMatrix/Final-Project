using System;
using System.Collections.Generic;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class PlayerSelectionHandler : MonoBehaviour, IPlayerSelectionHandler, IDependencyProvider
{
    [Provide, UsedImplicitly] IPlayerSelectionHandler Provide() => this;
    [SerializeField] List<Selectable> m_selectableList = new();


    public bool TrySelect(IPlayerControllable controllable, Transform playerSelection)
    {
        throw new NotImplementedException();
    }

    public bool TryGetNextAvailableSelection(Transform currentSelection, Vector2 direction, out Transform nextSelection)
    {
        throw new NotImplementedException();
    }

    public Vector2 GetNewSelectableLocation()
    {
        throw new NotImplementedException();
    }

    [Serializable]
    class Selectable
    {
        public bool CanHaveMultipleSelectors;
        public IPlayerControllable SelectedBy;
        public Transform Transform;
    }
}