using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.Serialization;

public class PauseMenu : MonoBehaviour
{
    [FormerlySerializedAs("pauseMenuUI")] [SerializeField] GameObject m_pauseMenuUI;
    [FormerlySerializedAs("togglePauseAction")] [SerializeField] InputActionReference m_togglePauseAction;
    [FormerlySerializedAs("pauseMenuVolume")] [SerializeField] Volume m_pauseMenuVolume;
    [SerializeField] private GameObject m_firstSelectedButton;
    void Start()
    {
        m_pauseMenuUI.SetActive(false);
    }

    void OnEnable()
    {
        if (m_togglePauseAction == null) return;
        m_togglePauseAction.action.Enable();
        m_togglePauseAction.action.performed += OnToggleMenu;
    }

    void OnDisable()
    {
        if (m_togglePauseAction == null) return;
        m_togglePauseAction.action.performed -= OnToggleMenu;
        m_togglePauseAction.action.Disable();
    }

    public void Resume()
    {
        m_pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        m_pauseMenuVolume.weight = 0;
        foreach (PlayerController controller in FindObjectsByType<PlayerController>(FindObjectsSortMode.None))
        {
            controller.TryChangeInputActionMap("Player", out _);
        }
    }

    public void Pause()
    {
        m_pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        m_pauseMenuVolume.weight = 1;

        foreach (PlayerController controller in FindObjectsOfType<PlayerController>())
        {
            controller.TryChangeInputActionMap("UI", out _);
            Debug.Log("Changed controller");
        }
        EventSystem.current.SetSelectedGameObject(null);
        EventSystem.current.SetSelectedGameObject(m_firstSelectedButton);
    }
    
    void OnToggleMenu(InputAction.CallbackContext context)
    {
        if(!m_pauseMenuUI.activeSelf) Pause();
        else Resume();
    }
}
