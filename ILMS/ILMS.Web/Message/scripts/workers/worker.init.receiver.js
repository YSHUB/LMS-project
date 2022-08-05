self.onmessage = function (e) {
    let selectedUser = e.data.selectedUser;
    let variables = e.data.variables;

    self.postMessage(selectedUser[0] + "|" + selectedUser[1] + "|" + selectedUser[2] + "|" + variables);
};