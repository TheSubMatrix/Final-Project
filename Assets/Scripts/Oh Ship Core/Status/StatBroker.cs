using System;
using System.Collections.Generic;

public class StatBroker
{
    readonly LinkedList<StatModifier> m_modifiers = new();
    EventHandler<StatQuery> m_queries;
    
    public void PerformStatQuery(object sender, StatQuery query) => m_queries?.Invoke(sender, query);

    public void AddModifier(StatModifier modifier)
    {
        modifier.OnDisposed += _ =>
        {
            m_modifiers.Remove(modifier);
            m_queries -= modifier.Handle;
        };
        m_modifiers.AddLast(modifier);
        m_queries += modifier.Handle;
    }

    void UpdateStats(float deltaTime)
    {
        LinkedListNode<StatModifier> node = m_modifiers.First;
        while (node != null)
        {
            node.Value.Update(deltaTime);
            node = node.Next;
        }
        node = m_modifiers.First;
        while(node != null)
        {
            LinkedListNode<StatModifier> next = node.Next;
            if (node.Value.MarkedForRemoval) node.Value.Dispose();
            node = next;
        }
    }
}