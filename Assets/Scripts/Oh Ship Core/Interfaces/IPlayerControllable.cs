using UnityEngine;
using UnityEngine.InputSystem;

public interface IPlayerControllable
{
    void OnControlRequested(IPlayerController player);
    void OnControlReleased();
}
