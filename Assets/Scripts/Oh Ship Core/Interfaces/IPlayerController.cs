using System.Diagnostics.Contracts;
using UnityEngine;
using UnityEngine.InputSystem;
/// <summary>
/// Represents a player's control of an object. Allows the player to request control of an object and to change the <see cref="InputActionAsset"/> used by the object.
/// </summary>
public interface IPlayerController
{
    /// <summary>
    /// Changes the controlled <see cref="IPlayerControllable"/> to the one specified.
    /// </summary>
    /// <param name="controllable">The <see cref="IPlayerControllable"/> we want to have control over</param>
    void ChangeControlledEntity(IPlayerControllable controllable);
    /// <summary>
    /// Changes the <see cref="InputActionMap"/> used by the controlled <see cref="IPlayerControllable"/> to the one specified.
    /// </summary>
    /// <param name="actions">The name of the <see cref="InputActionMap"/> to change to</param>
    /// <param name="newMap">The new <see cref="InputActionMap"/> that was swapped to. Meant so the caller can subscribe events to the map for their control scheme</param>
    /// <returns>Whether the action map change was successful</returns>
    public bool ChangeInputActionMap(string actions, out InputActionMap newMap);
    /// <summary>
    /// Gets the current <see cref="InputActionMap"/> used by the controlling <see cref="IPlayerController"/>
    /// </summary>
    /// <param name="currentMap">The current map used by the <see cref="IPlayerController"/></param>
    /// <returns>Whether the result is valid</returns>
    public bool GetCurrentInputActionMap(out InputActionMap currentMap);

    public GameObject GetAssociatedGameObject();
}