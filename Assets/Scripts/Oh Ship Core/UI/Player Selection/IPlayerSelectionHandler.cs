using UnityEngine;

public interface IPlayerSelectionHandler
{
    bool TryConfirmSelection(IPlayerControllable controllable, IPlayerSelection playerSelection);
    bool TryCancelSelection(IPlayerControllable controllable, IPlayerSelection playerSelection);
    bool TryGetNextAvailableSelection(IPlayerControllable selector, IPlayerSelection currentSelection, Vector2 direction, out IPlayerSelection nextSelection);
    
    IPlayerSelection GetDefaultSelectionZone();
}
