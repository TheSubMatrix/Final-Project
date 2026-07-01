using UnityEngine;
using UnityEngine.InputSystem;

public class PauseMenu : MonoBehaviour
{
    [SerializeField] GameObject pauseMenuUI;
    [SerializeField] InputActionReference togglePauseAction;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        pauseMenuUI.SetActive(false);
    }

    void OnEnable()
    {
        if (togglePauseAction != null)
        {
            togglePauseAction.action.Enable();
            togglePauseAction.action.performed += OnToggleMenu;
        }
    }

    void OnDisable()
    {
        if (togglePauseAction != null)
        {
            togglePauseAction.action.performed -= OnToggleMenu;
            togglePauseAction.action.Disable();
        }
    }

    public void Resume()
    {
        if(!pauseMenuUI.activeSelf) return;
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
    }
    
    void OnToggleMenu(InputAction.CallbackContext context)
    {
        if(!pauseMenuUI.activeSelf)
        {
            pauseMenuUI.SetActive(true);
            Time.timeScale = 0f;
        }
        else
        {
            pauseMenuUI.SetActive(false);
            Time.timeScale = 1f;
        }
    }
}
