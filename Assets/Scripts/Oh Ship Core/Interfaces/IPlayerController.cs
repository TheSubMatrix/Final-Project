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
    
    public bool ChangeInputActionMap(string actions, out InputActionMap newMap);
}