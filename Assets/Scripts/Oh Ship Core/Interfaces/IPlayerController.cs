using UnityEngine.InputSystem;

public interface IPlayerController
{
    void ChangeControlledEntity(IPlayerControllable controllable);
    public bool ChangeInputActions(InputActionAsset actions);
}