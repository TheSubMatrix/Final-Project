using UnityEngine;

public interface IPlayerSelectionHandler
{
    bool TrySelect(IPlayerControllable controllable, Transform playerSelection);
    bool TryGetNextAvailableSelection(Transform currentSelection, Vector2 direction, out Transform nextSelection);
    Vector2 GetNewSelectableLocation();
}