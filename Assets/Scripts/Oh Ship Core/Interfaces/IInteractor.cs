using System.Diagnostics.Contracts;
using UnityEngine;

/// <summary>
/// Represents an object that can interact with other <see cref="IInteractable"/>s.
/// </summary>
public interface IInteractor
{
    /// <returns>Whether the <see cref="IInteractor"/> is interacting with a <see cref="IInteractable"/></returns>
    [Pure] bool IsInteracting();
    // :( This is a hack to handle holding objects
    bool IsHoldingObject();
    /// <returns>The current <see cref="InteractionSession"/> if the <see cref="IInteractor"/> is interacting with a <see cref="IInteractable"/></returns>
    [Pure] InteractionSession GetSession();
    /// <summary>
    /// Requests the <see cref="InteractionSession"/> to be transferred to this <see cref="IInteractor"/>
    /// </summary>
    /// <param name="session">The <see cref="InteractionSession"/> to request the transfer of</param>
    /// <returns>True if the session transfer was successful</returns>
    bool RequestSessionTransfer(InteractionSession session);
    /// <returns>The <see cref="GameObject"/> associated with this <see cref="IInteractor"/></returns>
    [Pure] GameObject GetAssociatedGameObject();
}