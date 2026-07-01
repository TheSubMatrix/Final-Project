using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_Dropdown))]
public class ResolutionDropdown : MonoBehaviour
{
    TMP_Dropdown m_dropdown;
    List<Resolution> m_resolutions;

    void Start()
    {
        m_dropdown = GetComponent<TMP_Dropdown>();
        ParseResolutions();
        m_dropdown.onValueChanged.AddListener(OnDropdownValueChanged);
    }

    void OnDropdownValueChanged(int value) =>
        Screen.SetResolution(m_resolutions[value].width, m_resolutions[value].height, Screen.fullScreenMode);

    void ParseResolutions()
    {
        List<Resolution> resolutions = Screen.resolutions.ToList();
        HashSet<(int width, int height)> seen = new();
        int activeIndex = -1;

        for (int i = resolutions.Count - 1; i >= 0; i--)
        {
            if (!seen.Add((resolutions[i].width, resolutions[i].height)))
            {
                resolutions.RemoveAt(i);
                continue;
            }
            if (resolutions[i].width == Screen.width && resolutions[i].height == Screen.height)
                activeIndex = i;
        }

        m_resolutions = resolutions;
        m_dropdown.ClearOptions();
        m_dropdown.AddOptions(m_resolutions.Select(res => $"{res.width} x {res.height}").ToList());
        m_dropdown.SetValueWithoutNotify(activeIndex);
        Debug.Log($"Screen: {Screen.width}x{Screen.height}");
    }
}