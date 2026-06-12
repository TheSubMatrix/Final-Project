using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerSelectionSetup : MonoBehaviour
{
    [Inject] IPlayerSelectionHandler m_playerSelectionHandler;
    [SerializeField] PlayerSelectionCard m_playerSelectionCardPrefab;
    public void SetupCardSelection(PlayerInput playerInput)
    {
        PlayerSelectionCard card = Instantiate(m_playerSelectionCardPrefab, transform);
    }
}
