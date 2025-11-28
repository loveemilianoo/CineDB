<<<<<<< HEAD
/*package com.mycompany.cinedb.dao;

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
*/
=======
package dao;

import conexion.Conexion;
import entity.Sala;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaDAO {
    
    public List<Sala> getSalas() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Sala> salas = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM sala ORDER BY id_sala ASC";
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Sala sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
                salas.add(sala);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return salas;
    }
    
    public Sala getSalaPorId(int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        Sala sala = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM sala WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return sala;
    }
    
    public void insertarSala(Sala sala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO sala (numero_sala, capacidad) VALUES (?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void actualizarSala(Sala sala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE sala SET numero_sala = ?, capacidad = ? WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());
            ps.setInt(3, sala.getIdSala());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void eliminarSala(int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM sala WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
}
>>>>>>> 48827a88d352ec6a1036bf75a42af88d2f1505f4
