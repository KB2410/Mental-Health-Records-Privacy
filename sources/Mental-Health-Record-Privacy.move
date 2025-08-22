module MyModule::MentalHealthRecords {

    use aptos_framework::signer;

    /// Struct to store a user’s mental health record
    struct Record has store, key {
        notes: vector<u8>,   // Encrypted/encoded mental health notes
        is_private: bool,    // Privacy flag (true = only owner can read)
    }

    /// Function to create or update a private mental health record
    public fun set_record(owner: &signer, notes: vector<u8>, is_private: bool) {
        let record = Record {
            notes,
            is_private,
        };
        // Store the record under the user’s account
        move_to(owner, record);
    }

    /// Function to view a record (only owner can access if marked private)
    public fun view_record(requester: &signer, record_owner: address): vector<u8> acquires Record {
        let record = borrow_global<Record>(record_owner);

        // Check privacy rules
        if (record.is_private) {
            assert!(signer::address_of(requester) == record_owner, 1);
        };

        record.notes
    }
}
