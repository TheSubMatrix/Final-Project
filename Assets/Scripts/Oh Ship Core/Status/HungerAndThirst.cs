using MatrixUtils.GenericDatatypes;
using System.Collections.Generic;
using UnityEngine;

public class HungerAndThirst: MonoBehaviour
{

    [SerializeField] StatData hungerStat;
    [SerializeField] StatData thirstStat;
    [SerializeField] Observer<float> hunger = new Observer<float>();
    [SerializeField] Observer<float> thirst = new Observer<float>();


    public StatBroker broker = new StatBroker();


    private Dictionary<StatData, float> stats;
    
    private void Start()
    {
        
    }
    private void Update()
    { 
        StatQuery value = new StatQuery(hungerStat, 0.5f);
        broker.PerformStatQuery(this, value);
        hunger.Value = value.Value;
        hunger.Notify();
       // Debug.Log(value.Value);
    }

    public void OnPlayerControllerConnected(IPlayerController controller)
    {
        StatusBarManager manager = controller.GetAssociatedGameObject().transform.root.GetComponentInChildren<StatusBarManager>();
        hunger.AddListener(hunger => manager.UpdateHungerBar(hunger));
    }

    public void OnPlayerControllerDisconnected(IPlayerController controller)
    {
        StatusBarManager manager = controller.GetAssociatedGameObject().transform.root.GetComponentInChildren<StatusBarManager>();
        hunger.RemoveListener(hunger => manager.UpdateHungerBar(hunger));
    }




}
