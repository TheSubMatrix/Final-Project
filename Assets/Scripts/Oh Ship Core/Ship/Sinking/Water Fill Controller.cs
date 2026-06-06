using UnityEngine;

public class WaterFillController : MonoBehaviour
{
    [SerializeField] float m_topFill;
    [SerializeField] float m_bottomFill;
    public void UpdateWaterFill(float fill)
    {
        transform.localPosition = new Vector3(0, Mathf.Lerp(m_bottomFill, m_topFill, fill), 0);
    }
}
