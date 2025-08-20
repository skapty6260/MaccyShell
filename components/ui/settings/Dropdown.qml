Item {
    id: root

    property string Label: "Dropdown Option"
    property var options: [{ label: "Option #1", val: 1 }, { label: "Option #2", val: 2}]

    ComboBox {
        id: menu
        width: 200
        model: ["Option A", "Option B", "Option C", "Option D"] // Define the items in the dropdown

        onCurrentIndexChanged: {
            console.log("Selected item:", myComboBox.model[myComboBox.currentIndex]);
        }
    }
}