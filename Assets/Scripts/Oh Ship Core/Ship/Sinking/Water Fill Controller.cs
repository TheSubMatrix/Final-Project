using UnityEngine;
using UnityEngine.Events;

public class WaterFillController : MonoBehaviour
{
    [SerializeField] float m_topFill;
    [SerializeField] float m_bottomFill;
    [SerializeField] public UnityEvent<float> OnWaterFillChanged;
    
    public void UpdateWaterFill(float fill)
    {
        transform.localPosition = new(transform.localPosition.x, Mathf.Lerp(m_bottomFill, m_topFill, fill), transform.localPosition.z);
        OnWaterFillChanged?.Invoke(transform.position.y);
    }
}
