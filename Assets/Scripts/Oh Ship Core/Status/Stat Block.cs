using System.Collections.Generic;

public class StatBlock
{
    public StatBroker Broker { get; } = new();
    readonly Dictionary<StatData, float> m_stats = new();
    public bool Register(StatData stat, float value) => m_stats.TryAdd(stat, value);
    public bool Unregister(StatData stat) => m_stats.Remove(stat);
    public bool TryGetStat(StatData stat, out float value)
    {
        value = 0;
        if (!m_stats.TryGetValue(stat, out float baseValue)) return false;
        StatQuery query = new(stat, baseValue);
        Broker.PerformStatQuery(this, query);
        value = query.Value;
        return true;
    }
}