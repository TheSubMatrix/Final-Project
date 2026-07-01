using UnityEngine;
using UnityEngine.InputSystem;

public class PauseMenu : MonoBehaviour
{
    [SerializeField] private GameObject pauseMenuUI;
    [SerializeField] private InputActionReference togglePauseAction;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        pauseMenuUI.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnEnable()
    {
        if (togglePauseAction != null)
        {
            togglePauseAction.action.Enable();
            togglePauseAction.action.performed += OnToggleMenu;
        }
    }

    private void OnDisable()
    {
        if (togglePauseAction != null)
        {
            togglePauseAction.action.performed -= OnToggleMenu;
            togglePauseAction.action.Disable();
        }
    }

    private void OnToggleMenu(InputAction.CallbackContext context)
    {
        Debug.Log("Menu toggled!");

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
