import torch
import torch.nn as nn
import torch.optim as optim

def train_local_model(global_model, local_data):
    model = global_model
    optimizer = optim.SGD(model.parameters(), lr=0.01)

    for inputs, targets in local_data:
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = nn.CrossEntropyLoss()(outputs, targets)
        loss.backward()
        optimizer.step()

    gradients = {name: param.grad.clone() for name, param in model.named_parameters()}
    return compress_gradients(gradients)

def compress_gradients(gradients):
    compressed = {}
    for key, grad in gradients.items():
        if grad.abs().mean() > 0.01:
            compressed[key] = (grad * 1000).round() / 1000
    return compressed
