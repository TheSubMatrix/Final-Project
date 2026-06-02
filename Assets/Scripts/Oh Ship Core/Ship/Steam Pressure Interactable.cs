using UnityEngine;
/// <summary>
/// An interactable that allows the player to adjust the pressure of the steam engine in the ship.
/// </summary>
public class SteamPressureInteractable : MonoBehaviour, IInteractable
{
    /// <inheritdoc/>
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        InteractionSession session = new(interactor, this);
        session.OnEnded += CleanupInteraction;
        return session;
    }
    void CleanupInteraction()
    {
        
    }
}
