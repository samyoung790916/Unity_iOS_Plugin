using System.Collections.Generic;

public class Postbox
{
    //싱글턴 인스턴스
    private static Postbox instance;
    //싱글턴 인스턴스 반환
    public static Postbox GetInstance
    {
        get
        {
            if (instance == null)
                instance = new Postbox();

            return instance;
        }
    }

    //데이타를 담을 큐
    private Queue<string> messageQueue;

    private Postbox()
    {   //큐 초기화
        messageQueue = new Queue<string>();
    }

    //큐에 데이타 삽입
    public void PushData(string data)
    {
        messageQueue.Enqueue(data);
    }

    //큐에있는 데이타 꺼내서 반환
    public string GetData()
    {
        //데이타가 1개라도 있을 경우 꺼내서 반환
        if (messageQueue.Count > 0)
            return messageQueue.Dequeue();
        else
            return string.Empty;    //없으면 빈값을 반환
    }
}
