using MatrixUtils.GenericDatatypes;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class HungerAndThirst: MonoBehaviour
{
    [FormerlySerializedAs("m_hunger")] [FormerlySerializedAs("hunger")] public Observer<float> Hunger = new(0.5f);
    [FormerlySerializedAs("m_thirst")] [FormerlySerializedAs("thirst")] public Observer<float> Thirst = new(1f);
    [FormerlySerializedAs("manager")] [SerializeField] StatusBarManager m_manager;

    void Start()
    {
        Hunger.Notify();
        Thirst.Notify();
    }

    public void OnPlayerControllerConnected(IPlayerController controller)
    {
        m_manager = controller.GetAssociatedGameObject().transform.root.GetComponentInChildren<StatusBarManager>();
        Hunger.AddListener(m_manager.UpdateHungerBar);
    }

    public void OnPlayerControllerDisconnected(IPlayerController controller)
    {
        Hunger.RemoveListener(m_manager.UpdateHungerBar);
        m_manager = null;
    }
    void UpdateHungerBar(float hunger) => m_manager.UpdateHungerBar(hunger);
}
