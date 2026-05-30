using System;

public class SimpleStatModifier : StatModifier
{
    readonly StatData m_stat;
    readonly Func<float, float> m_modifier;
    public SimpleStatModifier(StatData data, float scale, Func<float, float> modifier, StatData stat)
    {
        m_modifier = modifier;
        m_stat = stat;
    }
    public override void Update(float deltaTime)
    {
        
    }

    public override void Handle(object sender, StatQuery query)
    {
        if (query.Data != m_stat) return;
        query.Value = m_modifier(query.Value);
    }
}