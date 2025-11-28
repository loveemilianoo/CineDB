package com.mycompany.cinedb.dao;

import com.mycompany.cinedb.conexion.Conexion;
import com.mycompany.cinedb.entity.Sala;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SalaDAO {
    public boolean agregarSala(Sala sala) {
        String sql = "INSERT INTO sala (numero_sala, capacidad) VALUES (?, ?)";
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());

            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Sala> listarSalas() {
        List<Sala> lista = new ArrayList<>();
        String sql = "SELECT * FROM sala";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Sala sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
                lista.add(sala);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Sala obtenerSala(int id) {
        Sala sala = null;
        String sql = "SELECT * FROM sala WHERE id_sala = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sala;
    }

    public boolean actualizarSala(Sala sala) {
        String sql = "UPDATE sala SET numero_sala = ?, capacidad = ? WHERE id_sala = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());
            ps.setInt(3, sala.getIdSala());

            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarSala(int id) {
        String sql = "DELETE FROM sala WHERE id_sala = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
