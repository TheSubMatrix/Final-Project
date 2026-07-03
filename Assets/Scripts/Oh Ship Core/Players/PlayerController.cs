using System;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;

public class PlayerController : MonoBehaviour, IPlayerController
{
    [SerializeField] PlayerInput m_playerInput;
    [SerializeField] InterfaceReference<IPlayerControllable> m_defaultControllable;
    IPlayerControllable m_currentControlledEntity;
    /// <inheritdoc/>
    public void ChangeControlledEntity(IPlayerControllable controllable)
    {
        //Debug.Log("Changing controlled entity");
        if (m_currentControlledEntity == controllable) return;
        m_currentControlledEntity?.OnControlReleased();
        m_currentControlledEntity = controllable ?? m_defaultControllable.Value;
        m_currentControlledEntity.OnControlRequested(this);
    }
    /// <inheritdoc/>
    public bool TryChangeInputActionMap(string actions, out InputActionMap newMap)
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
    /// <inheritdoc/>
    public bool TryGetCurrentInputActionMap(out InputActionMap currentMap)
    {
        currentMap = m_playerInput.currentActionMap;
        return currentMap != null;
    }

    void Start()
    {
        m_playerInput.uiInputModule = FindFirstObjectByType<InputSystemUIInputModule>();
        DontDestroyOnLoad(gameObject);
    }
    /// <inheritdoc/>
    public GameObject GetAssociatedGameObject() => gameObject;
    /// <summary>
    /// Returns the player index of the player that owns this controller.
    /// </summary>
    /// <param name="playerIndex">The resulting index from the player</param>
    /// <returns>Whether the resulting index is valid</returns>
    public bool TryGetPlayerIndex(out int playerIndex)
    {
        playerIndex = -1;
        if (m_playerInput == null) return false;
        playerIndex = m_playerInput.playerIndex;
        return true;
    }
}