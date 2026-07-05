using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
public class HelpMenuManager : MonoBehaviour
{
    public static HelpMenuManager Instance;
    [Header("This is the Canvas holding the image you are focusing on when you select a picture")]
    [SerializeField] private GameObject helpMenu;
    
    [Header("This is the literal picture labeled Focus Image so that is what the sprite changes to")]
    [SerializeField] private Image focusImage;
    
    [Header("The text you want to display for the help picture")]
    [SerializeField] private TextMeshProUGUI focusText;
    [Header("The help picture back button that is on the canvas of the Help Display Canvas")]
    [SerializeField] private GameObject helpMenuFocusBackButton;
    [Header("The original back button for the scene itself\nthe one that takes you back to the Main Menu")]
    [SerializeField] private GameObject helpMenuBackButton;

    void Awake()
    {
        Instance = this;
    }

    public void ShowHelp(string text, Sprite sprite)
    {
        helpMenu.SetActive(true);
        focusText.text = text;
        if(sprite != null)
        {
            focusImage.sprite = sprite;
        }
        EventSystem.current.SetSelectedGameObject(helpMenuFocusBackButton);
    }
    
    public void HideHelp()
    {
        helpMenu.SetActive(false);
        EventSystem.current.SetSelectedGameObject(helpMenuBackButton);

    }
}
