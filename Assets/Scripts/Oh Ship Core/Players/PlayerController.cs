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
    public bool ChangeInputActions(InputActionAsset actions)
    {
        if (actions is null) return false;
        if(m_playerInput.actions) m_playerInput.actions.Disable();
        if(!actions.enabled) actions.Enable();
        m_playerInput.actions = actions;
        return true;
    }
}