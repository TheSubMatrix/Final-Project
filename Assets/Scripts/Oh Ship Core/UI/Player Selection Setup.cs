using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;

public class PlayerSelectionSetup : MonoBehaviour
{
    [SerializeField] GameObject[] m_playerInputUIStartPoints;
    [SerializeField] Canvas m_selectionCanvas;

    public void OnPlayerJoined(PlayerInput playerInput)
    {
        if (!m_playerInputUIStartPoints[playerInput.playerIndex]) return;
        MultiplayerEventSystem eventSystem = playerInput.transform.root.GetComponentInChildren<MultiplayerEventSystem>();
        eventSystem.playerRoot = m_selectionCanvas.gameObject;
        eventSystem.firstSelectedGameObject = m_playerInputUIStartPoints[playerInput.playerIndex];
        StartCoroutine(SetInitialSelection(eventSystem, m_playerInputUIStartPoints[playerInput.playerIndex]));
    }
    //Janky way to set the first selected object, for some reason, the selection system needs to be deferred a frame so the system has time to process it, or else it doesn't work. Thanks Unity, very cool!
    IEnumerator SetInitialSelection(MultiplayerEventSystem eventSystem, GameObject selection)
    {
        yield return null;
        eventSystem.SetSelectedGameObject(null);
        eventSystem.SetSelectedGameObject(selection);
    }
}