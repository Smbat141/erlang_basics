# from multiprocessing import Process, Queue
#
#
# def receiver(n, q, m):
#     print(q.get(), n)
#     go_ring(n - 1, q, m)
#
#
# def go_ring(n, q, m):
#     if n == 0:
#         return
#
#     q.put(m)
#     receiver_process = Process(target=receiver, args=(n, q, m))
#     receiver_process.start()
#
#
# def send_ring_message(times, ring_count, message):
#     for _ in range(times):
#         q = Queue()
#         go_ring(ring_count, q, message)
#
#
# send_ring_message(8, 1000, "Hello world")
#
#


from multiprocessing import Process, Queue


def ring_loop(q, id):
    q.put(id)
    for i in range(num_processes):
        message = q.get()
        print(f'Process {id} received message: {message}')
        q.put(message)


num_processes = 5
processes = []
queues = [Queue() for _ in range(num_processes)]

for i in range(num_processes):
    p = Process(target=ring_loop, args=(queues[i], i))
    processes.append(p)
    p.start()


print("Ring completed")
