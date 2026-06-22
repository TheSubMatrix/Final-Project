using System.Collections;
using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;

public class CharacterSelectionSpawnManager : MonoBehaviour
{
    [Inject] IInjector m_injector;
    [SerializeField] PlayerInputManager m_playerInputManager;
    [SerializeField] Canvas m_playerSelectionCanvasPrefab;
    [SerializeField] Canvas m_displayCanvas;
    public void OnSpawn(PlayerInput playerInput)
    {
        if(playerInput.transform.root.GetComponentInChildren<MultiplayerEventSystem>() is not {} multiplayerEventSystem) return;
        StartCoroutine(SpawnPlayerSelectionCanvas(multiplayerEventSystem));
    }

    IEnumerator SpawnPlayerSelectionCanvas(MultiplayerEventSystem multiplayerEventSystem)
    {
        yield return null;
        Canvas selectionCanvas = Instantiate(m_playerSelectionCanvasPrefab);
        m_injector.Inject(selectionCanvas.gameObject);
        multiplayerEventSystem.playerRoot = selectionCanvas.gameObject;
        Debug.Log("Setting player root");
        if (!TryGetChildWithTag(selectionCanvas.transform, "Multiplayer UI Start Position", out Transform startPosition)) yield break;
        Debug.Log("Found start position");
        multiplayerEventSystem.SetSelectedGameObject(startPosition.gameObject);
        multiplayerEventSystem.firstSelectedGameObject = startPosition.gameObject;
    }

    static bool TryGetChildWithTag(Transform transform, string tag, out Transform result)
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            Transform child = transform.GetChild(i);
            if (child.CompareTag(tag))
            {
                result = child;
                return true;
            }
            if (TryGetChildWithTag(child, tag, out result)) return true;
        }
        result = null;
        return false;
    }

}
