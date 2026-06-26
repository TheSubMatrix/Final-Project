using System.Linq;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_Dropdown))]
public class WindowModeDropdown : MonoBehaviour
{
    TMP_Dropdown m_dropdown;

    void Start()
    {
        m_dropdown = GetComponent<TMP_Dropdown>();
        m_dropdown.AddOptions(
            System.Enum.GetNames(typeof(FullScreenMode))
                .Select(modeName => System.Text.RegularExpressions.Regex.Replace(modeName, "(?<=[a-z])(?=[A-Z])", " "))
                .ToList()
        );
        m_dropdown.onValueChanged.AddListener(OnDropdownValueChanged);
        m_dropdown.SetValueWithoutNotify((int)Screen.fullScreenMode);
    }

    void OnDropdownValueChanged(int value) => Screen.fullScreenMode = (FullScreenMode)value;
}