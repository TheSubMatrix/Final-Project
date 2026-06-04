using System;
using System.Collections.Generic;
using Random = UnityEngine.Random;
public struct RandomBag<T>
{
    T[] m_items;
    int m_count;

    public int Count => m_count;
    public bool IsEmpty => m_count == 0;

    public RandomBag(IList<T> source)
    {
        m_items = new T[source.Count];
        source.CopyTo(m_items, 0);
        m_count = m_items.Length;
    }
        
    public T Take()
    {
        if (IsEmpty) throw new InvalidOperationException("Bag is empty.");
        int index = Random.Range(0, m_count);
        T item = m_items[index];
        m_items[index] = m_items[--m_count];
        return item;
    }
        
    public void Return(T item)
    {
        if (m_count >= m_items.Length)
            Array.Resize(ref m_items, m_items.Length * 2);
        m_items[m_count++] = item;
    }
}
