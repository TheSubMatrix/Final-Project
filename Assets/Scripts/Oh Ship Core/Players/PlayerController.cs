using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour, IPlayerController
{
    [SerializeField] PlayerInput m_playerInput;
    [SerializeField] InterfaceReference<IPlayerControllable> m_defaultControllable;
    IPlayerControllable m_currentControlledEntity;
    /// <inheritdoc/>
    public void ChangeControlledEntity(IPlayerControllable controllable)
    {
        if (m_currentControlledEntity == controllable) return;
        m_currentControlledEntity?.OnControlReleased();
        m_currentControlledEntity = controllable ?? m_defaultControllable.Value;
        m_currentControlledEntity.OnControlRequested(this);
    }
    /// <inheritdoc/>
    public bool ChangeInputActionMap(string actions, out InputActionMap newMap)
    {
        newMap = null;
        if (actions is null) return false;
        m_playerInput.currentActionMap?.Disable();
        newMap = m_playerInput.actions.FindActionMap(actions);
        if (newMap is null) return false;
        m_playerInput.SwitchCurrentActionMap(actions);
        newMap.Enable();
        return true;
    }

    void Start()
    {
        if(m_defaultControllable.Value is null) return;
        ChangeControlledEntity(m_defaultControllable.Value);
    }
}