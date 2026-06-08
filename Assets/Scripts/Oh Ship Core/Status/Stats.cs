using Codice.CM.Common;
using UnityEngine;
using System;

public enum StatType { Hunger, Thirst}
public class Stats
{
    readonly StatData baseStats;
    readonly StatBroker mediator;

    public StatBroker Mediator => mediator;

    /*
    public int Hunger
    {
        get
        {
            var q = new StatQuery(StatType.Hunger, baseStats.hunger);
            mediator.PerformQuery(this, q);
            return q.Value;
        }
    }

    public int Thirst
    {
        get
        {
            var q = new StatQuery(StatData.Thirst, baseStats.thirst);
            mediator.PerformQuery(this, q);
            return q.Value;
        }
    }

    public Stats(StatBroker mediator, StatData baseStats)
    {
        this.mediator = mediator;
        this.baseStats = baseStats;
    }

    public override string ToString() => $"Hunger: {Hunger}, Thirst: {Thirst}";

    */
}
